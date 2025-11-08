from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from pydantic import BaseModel
from typing import List
from datetime import datetime
import os
import traceback
import glob

from ..ai_client import call_ai_measurement

router = APIRouter()

class ProcessRequest(BaseModel):
    height: float
    weight: float
    userId: str

@router.post("/upload")
async def upload_photos(files: List[UploadFile] = File(...), userId: str = Form(...)):
    """
    Save uploaded photos to uploads/measurements and return saved paths.
    Clients: mobile app / web frontend (multipart/form-data).
    """
    upload_dir = "uploads/measurements/"
    os.makedirs(upload_dir, exist_ok=True)
    saved = []
    for f in files:
        if f.content_type not in ("image/jpeg", "image/png"):
            raise HTTPException(status_code=400, detail="Only JPEG/PNG allowed")
        filename = f"{int(datetime.utcnow().timestamp())}-{f.filename}"
        path = os.path.join(upload_dir, filename)
        content = await f.read()
        with open(path, "wb") as fh:
            fh.write(content)
        saved.append(path)
    return {"status": "success", "files": saved, "userId": userId}

@router.post("/process")
async def process_measurements(payload: ProcessRequest):
    """
    Process measurements by calling AI service with sample images.
    Falls back to mock data if AI service is unavailable.
    """
    # Define the mock fallback response
    mock = {
        "chest": 98,
        "waist": 82,
        "shoulders": 44,
        "armLength": 62,
        "neck": 38,
        "hip": 96,
        "height": payload.height,
        "weight": payload.weight,
        "unit": "cm",
    }
    
    # Try to call AI service with sample images from uploads
    try:
        upload_dir = "uploads/measurements/"
        os.makedirs(upload_dir, exist_ok=True)
        
        # Get sample image paths if they exist
        image_files = glob.glob(os.path.join(upload_dir, "*.[jp][pn][g]*"))
        sample_images = image_files[:5] if image_files else []
        
        # Prepare metadata
        metadata = {
            "userId": payload.userId,
            "height": payload.height,
            "weight": payload.weight,
            "timestamp": datetime.utcnow().isoformat() + "Z"
        }
        
        # Attempt to call AI service
        if sample_images:
            ai_result = await call_ai_measurement(sample_images, metadata)
            return {
                "status": "success",
                "message": "Measurements processed via AI service",
                "data": {
                    "measurements": ai_result.get("measurements", mock),
                    "userId": payload.userId,
                    "processedAt": datetime.utcnow().isoformat() + "Z",
                    "source": "ai_service"
                },
            }
        else:
            # No images available, return mock with note
            return {
                "status": "success",
                "message": "No images found - using mock data",
                "data": {
                    "measurements": mock,
                    "userId": payload.userId,
                    "processedAt": datetime.utcnow().isoformat() + "Z",
                    "source": "mock_no_images"
                },
            }
    
    except Exception as e:
        # AI service failed, return mock data with error info for debugging
        error_trace = traceback.format_exc()
        return {
            "status": "success",
            "message": "AI service unavailable - using mock data",
            "data": {
                "measurements": mock,
                "userId": payload.userId,
                "processedAt": datetime.utcnow().isoformat() + "Z",
                "source": "mock_fallback"
            },
            "debug": {
                "error": str(e),
                "trace": error_trace
            }
        }
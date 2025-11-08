"""
AI Client for measurement processing integration.
Provides async HTTP client for calling AI measurement service.
"""
import os
import httpx
from typing import List, Dict, Any, Optional


async def call_ai_measurement(
    images: List[str],
    metadata: Dict[str, Any]
) -> Dict[str, Any]:
    """
    Call AI measurement service to process images and extract measurements.
    
    Args:
        images: List of image file paths
        metadata: Dictionary containing additional metadata (userId, height, weight, etc.)
    
    Returns:
        Dict containing processed measurement results from AI service
    
    Raises:
        httpx.HTTPError: If the AI service request fails
        Exception: For other processing errors
    """
    ai_service_url = os.getenv("AI_SERVICE_URL", "http://localhost:8080")
    endpoint = f"{ai_service_url}/process_measurements"
    
    # Prepare the payload
    payload = {
        "images": images,
        "metadata": metadata
    }
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.post(endpoint, json=payload)
        response.raise_for_status()
        return response.json()

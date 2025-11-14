"""
Schemas package.
"""

from backend.schemas.user import UserRegister, UserLogin, Token, UserResponse
from backend.schemas.category import CategoryCreate, CategoryUpdate, CategoryResponse
from backend.schemas.design import DesignCreate, DesignUpdate, DesignResponse
from backend.schemas.fabric import FabricCreate, FabricUpdate, FabricResponse
from backend.schemas.color import ColorCreate, ColorUpdate, ColorResponse

__all__ = [
    "UserRegister",
    "UserLogin",
    "Token",
    "UserResponse",
    "CategoryCreate",
    "CategoryUpdate",
    "CategoryResponse",
    "DesignCreate",
    "DesignUpdate",
    "DesignResponse",
    "FabricCreate",
    "FabricUpdate",
    "FabricResponse",
    "ColorCreate",
    "ColorUpdate",
    "ColorResponse",
]

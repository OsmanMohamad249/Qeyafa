"""
Configuration settings for the application.
"""

import os
from typing import List, Optional
from pydantic_settings import BaseSettings
from pydantic import Field, validator, field_validator
from pydantic import ValidationInfo


class Settings(BaseSettings):
    """Application settings with environment variable validation"""
    REDIS_URL: str = Field(default=None, description="Redis connection URL", json_schema_extra={"env": "REDIS_URL"})

    # Environment Configuration
    ENVIRONMENT: str = Field(
        default="development",
        description="Application environment (development, staging, production)",
    )

    # Database - REQUIRED, no default for security
    DATABASE_URL: str = Field(
        ...,
        description="Database connection URL (e.g., postgresql://user:pass@host:port/db)",
    )
    # Extra fields to avoid Pydantic v2 validation errors
    POSTGRES_USER: Optional[str] = Field(default=None, description="Postgres username", json_schema_extra={"env": "POSTGRES_USER"})
    POSTGRES_PASSWORD: Optional[str] = Field(default=None, description="Postgres password", json_schema_extra={"env": "POSTGRES_PASSWORD"})
    POSTGRES_DB: Optional[str] = Field(default=None, description="Postgres database name", json_schema_extra={"env": "POSTGRES_DB"})

    # Security - REQUIRED, no default for security
    SECRET_KEY: str = Field(
        ...,
        description="Secret key for JWT token signing (must be kept secret)",
        min_length=32,
    )
    ALGORITHM: str = Field(
        default="HS256",
        description="Algorithm for JWT token encoding",
    )
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(
        default=30,
        description="Access token expiration time in minutes",
        ge=1,
    )

    # API
    API_V1_PREFIX: str = Field(
        default="/api/v1",
        description="API v1 prefix path",
    )

    # CORS Settings - More restrictive by default
    # Stored as string, accessed via property as list
    CORS_ORIGINS_STR: str = Field(
        default="http://localhost:3000,http://localhost:8080",
        description="Allowed CORS origins (comma-separated in env)",
        json_schema_extra={"env": "CORS_ORIGINS"},
    )

    # AI Service - Optional with sensible default
    AI_SERVICE_URL: str = Field(
        default="http://ai-models:8000",
        description="AI service URL for model inference",
    )

    # Debug mode - automatically set based on environment
    DEBUG: bool = Field(
        default=True,
        description="Debug mode (automatically False in production)",
    )

    @field_validator("ENVIRONMENT", mode="before")
    def validate_environment(cls, v, info: ValidationInfo):
        allowed = ["development", "staging", "production"]
        if v.lower() not in allowed:
            raise ValueError(f"ENVIRONMENT must be one of {allowed}, got: {v}")
        return v.lower()

    @field_validator("SECRET_KEY", mode="before")
    def validate_secret_key(cls, v, info: ValidationInfo):
        weak_keys = [
            "your-secret-key",
            "your-secret-key-change-this-in-production",
            "change-this",
            "secret",
            "password",
        ]
        if any(weak in v.lower() for weak in weak_keys):
            raise ValueError(
                "SECRET_KEY appears to be a weak/default value. "
                "Please set a strong secret key in your environment variables."
            )
        return v

    @field_validator("DEBUG", mode="before")
    def set_debug_mode(cls, v, info: ValidationInfo):
        env = info.data.get("ENVIRONMENT") if info.data else None
        if env == "production":
            return False
        return v

    @property
    def CORS_ORIGINS(self) -> List[str]:
        """Parse and return CORS origins as a list"""
        return [origin.strip() for origin in self.CORS_ORIGINS_STR.split(",")]

    @property
    def is_development(self) -> bool:
        """Check if running in development mode"""
        return self.ENVIRONMENT == "development"

    @property
    def is_staging(self) -> bool:
        """Check if running in staging mode"""
        return self.ENVIRONMENT == "staging"

    @property
    def is_production(self) -> bool:
        """Check if running in production mode"""
        return self.ENVIRONMENT == "production"

    model_config = {
        "env_file": [".env", ".env.test"] if os.getenv("TESTING") else ".env",
        "env_file_encoding": "utf-8",
        "case_sensitive": True,
        "extra": "ignore",
    }


settings = Settings()

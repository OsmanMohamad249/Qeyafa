"""add templates and assets tables

Revision ID: 20251116_templates_assets
Revises: f8c9d1e2a3b4
Create Date: 2025-11-16 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '20251116_templates_assets'
down_revision = '575410277ca3'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # This migration became a duplicate of 20251115_templates_assets
    # Keep the revision in place but make it a no-op so Alembic does
    # not attempt to create tables that already exist when both
    # branches are merged/applied in CI.
    return


def downgrade() -> None:
    # No-op downgrade for duplicate migration.
    return

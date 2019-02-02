from typing import Optional

from pydantic import BaseModel, EmailStr, UrlStr

from app.core.security import verify_password, generate_salt, get_password_hash
from .dbmodel import DBModelMixin


class UserBase(BaseModel):
    username: str
    email: EmailStr
    bio: Optional[str] = ""
    image: Optional[UrlStr] = None


class UserInDB(DBModelMixin, UserBase):
    salt: str = ""
    hashed_password: str = ""

    def check_password(self, password: str):
        return verify_password(self.salt + password, self.hashed_password)

    def change_password(self, password: str):
        self.salt = generate_salt()
        self.hashed_password = get_password_hash(self.salt + password)


class User(UserBase):
    token: str


class UserInResponse(BaseModel):
    user: User


class UserInLogin(BaseModel):
    email: EmailStr
    password: str


class UserInCreate(UserInLogin):
    username: str


class UserInUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    bio: Optional[str] = None
    image: Optional[UrlStr] = None
import requests

API_URL = "http://localhost:8000/api/v1"
ADMIN_EMAIL = "admin@example.com"
ADMIN_PASSWORD = "password123"

# 1. Login as admin to get JWT
def get_admin_token():
    resp = requests.post(f"{API_URL}/auth/login", data={"username": ADMIN_EMAIL, "password": ADMIN_PASSWORD})
    resp.raise_for_status()
    return resp.json()["access_token"]

# 2. Create designer user
def test_create_designer(token):
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    data = {
        "email": "designer3@example.com",
        "password": "designerpass",
        "first_name": "Designer3",
        "last_name": "User",
        "role": "designer"
    }
    resp = requests.post(f"{API_URL}/admin/admin-create-user", json=data, headers=headers)
    print("Create designer:", resp.status_code, resp.json())

# 3. List users
def test_list_users(token):
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(f"{API_URL}/admin/users", headers=headers)
    print("List users:", resp.status_code, resp.json())
    return resp.json()

# 4. Update designer user
def test_update_user(token, user_id):
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    data = {"first_name": "UpdatedDesigner"}
    resp = requests.put(f"{API_URL}/admin/users/{user_id}", json=data, headers=headers)
    print("Update user:", resp.status_code, resp.json())

# 5. Delete designer user
def test_delete_user(token, user_id):
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.delete(f"{API_URL}/admin/users/{user_id}", headers=headers)
    print("Delete user:", resp.status_code, resp.json())

if __name__ == "__main__":
    token = get_admin_token()
    test_create_designer(token)
    users = test_list_users(token)
    # Find designer3 user id
    designer_user = next((u for u in users if u["email"] == "designer3@example.com"), None)
    if designer_user:
        user_id = designer_user["id"]
        test_update_user(token, user_id)
        test_delete_user(token, user_id)
    else:
        print("Designer3 user not found for update/delete.")

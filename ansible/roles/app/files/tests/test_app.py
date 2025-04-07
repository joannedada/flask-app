from ansible.roles.app.files.app import app


def test_home_route():
    """Test if home route returns 200 OK"""
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200  # nosec B101

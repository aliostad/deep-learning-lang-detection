package fantasy

/*import (
	"encoding/json"
	"testing"
)*/

/*func TestManagerUnmarshal(t *testing.T) {
	j := []byte(`{
		"manager": {
			"manager_id": "4",
			"nickname": "Shane",
			"guid": "ABC",
			"is_current_login": "1",
			"email": "slickrickjamesbrown@gmail.com",
			"image_url": "https://s.yimg.com/dh/ap/social/profile/profile_b64.png"
		}
	}`)

	manager := Manager{}
	err := json.Unmarshal(j, &manager)

	if err != nil {
		t.Errorf("Could not unmarshal manager: %v", err)
	}

	if manager.ManagerID != "4" {
		t.Errorf("Manager unmarshal produced incorrect ManagerId: got %s expected %s", manager.ManagerID, "4")
	}
	if manager.Name != "Shane" {
		t.Errorf("Manager unmarshal produced incorrect Name: got %s expected %s", manager.Name, "Shane")
	}
	if manager.Guid != "ABC" {
		t.Errorf("Manager unmarshal produced incorrect Guid: got %s expected %s", manager.Guid, "ABC")
	}
	if !manager.IsCurrentLogin {
		t.Errorf("Manager unmarshal produced incorrect IsCurrentLogin: got %t expected %t",
			manager.IsCurrentLogin, true)
	}
	if manager.Email != "slickrickjamesbrown@gmail.com" {
		t.Errorf("Manager unmarshal produced incorrect Email: got %s expected %s", manager.Email, "slickrickjamesbrown@gmail.com")
	}
	if manager.ImageURL != "https://s.yimg.com/dh/ap/social/profile/profile_b64.png" {
		t.Errorf("Manager unmarshal produced incorrect ImageURL: got %s expected %s",
			manager.ImageURL, "https://s.yimg.com/dh/ap/social/profile/profile_b64.png")
	}
}*/

/*func UnmarshalManagerList(t *testing.T) {
	j := []byte(`{
		"managers": [
			{
				"manager": {
					"manager_id": "1",
					"nickname": "Manager 1",
					"guid": "ABC",
					"is_current_login": "0",
					"email": "manager1@yahoo.com",
					"image_url": "https://s.yimg.com/manager1.png"
				}
			},
			{
				"manager": {
					"manager_id": "2",
					"nickname": "Manager 2",
					"guid": "DEF",
					"is_current_login": "1",
					"email": "manager2@yahoo.com",
					"image_url": "https://s.yimg.com/manager2.png"
				}
			}
		]
	}`)

	managers := []Manager{}

	err := json.Unmarshal(j, &managers)

	if err != nil {
		t.Errorf("Could not unmarshal manager: %v", err)
	}
}*/

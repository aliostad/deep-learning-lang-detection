(ns carpe-diem.constants)

(def base-url "https://carpediem3.aidbox.io")

(def patient-endpoint (str base-url "/fhir/Patient"))

(def auth-uri (str "https://carpediem.auth0.com/authorize?"
                   "response_type=token&"
                   "client_id=e6RPalLVenMV-hDiNO0L1tUdQ5qmKbKs&"
                   "redirect_uri=https%3A%2F%2Fmanage.auth0.com%2Ftester%2Fcallback&"
                   "connection=aidbox"))

(def callback-uri "https://manage.auth0.com/tester/callback#")

(def userinfo-uri "https://carpediem.auth0.com/userinfo?access_token=")


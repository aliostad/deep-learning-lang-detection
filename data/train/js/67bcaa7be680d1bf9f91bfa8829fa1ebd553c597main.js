const express = require('express')
const router = express.Router()

const authController = require('../controller/authController')
const archiveController = require('../controller/archiveController')
const infoController = require('../controller/infoController')

const {
  catchErrors
} = require('../handlers/errorHandlers')

router.get('/', catchErrors(archiveController.getArchives))

router.get('/register', authController.registerForm)
router.post('/register',
  catchErrors(authController.register),
  authController.login
)

router.get('/profile', authController.isLoggedIn, authController.profile)

router.get('/contact', infoController.contact)

router.get('/healthcheck', infoController.healthcheck)

// logout from all authentication
router.get('/logout', authController.logout)

module.exports = router

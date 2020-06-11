using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Omnipresence.DataAccess.Core;
using System.Security.Cryptography;

namespace Omnipresence.Processing
{
    public class ApiServices:IDisposable
    {
        #region [FIELDS]

        private OmnipresenceEntities db;
        private static ApiServices instance;

        #endregion

        #region [CONSTRUCTOR]

        private ApiServices()
        {
            db = new OmnipresenceEntities();
            db.Connection.Open();
        }

        public static ApiServices GetInstance()
        {
            if (instance == null)
            {
                instance = new ApiServices();
            }

            return instance;
        }

        #endregion

        #region [CRUD]

        public bool CreateApiUser(CreateApiUserModel caum)
        {
            ApiUser apiUser = new ApiUser();
            apiUser.ApiKey = caum.ApiKey;
            apiUser.Email = caum.Email;
            apiUser.AppName = caum.AppName;
            apiUser.LastCallDate = DateTime.Now;
            apiUser.ApiCallCount = 0;

            db.AddToApiUsers(apiUser);
            db.SaveChanges();

            return true;
        }

        public bool UpdateApiUser(ApiUserModel aum)
        {
            ApiUser apiUser = db.ApiUsers.Where(u => u.ApiUserId == aum.ApiUserId).FirstOrDefault();

            if (apiUser != null)
            {
                apiUser.ApiKey = aum.ApiKey;
                apiUser.ApiCallCount = aum.ApiCallCount;
                apiUser.LastCallDate = aum.LastCallDate;
                apiUser.AppName = aum.AppName;
                apiUser.Email = aum.Email;
                db.SaveChanges();

                return true;
            }
            else
            {
                return false;
            }
        }

        public bool DeleteApiUser(DeleteApiUserModel daum)
        {
            ApiUser apiUser = db.ApiUsers.Where(u => u.ApiUserId == daum.ApiUserId).FirstOrDefault();

            if (apiUser != null)
            {
                db.DeleteObject(apiUser);
                db.SaveChanges();

                return true;
            }
            else
            {
                return false;
            }
        }

        #endregion

        #region [SEARCH]

        public ApiUserModel GetApiUserById(int id)
        {
            ApiUser apiUser = db.ApiUsers.Where(account => account.ApiUserId == id).FirstOrDefault();
            ApiUserModel apiUserModel = Utilities.ApiUserToApiUserModel(apiUser);

            return apiUserModel;
        }

        public ApiUserModel GetApiUserByEmail(string email)
        {
            ApiUser apiUser = db.ApiUsers.Where(account => account.Email == email).FirstOrDefault();
            ApiUserModel apiUserModel = Utilities.ApiUserToApiUserModel(apiUser);

            return apiUserModel;
        }

        public ApiUserModel GetApiUserByApiKey(string apiKey)
        {
            ApiUser apiUser = db.ApiUsers.Where(account => account.ApiKey == apiKey).FirstOrDefault();
            ApiUserModel apiUserModel = Utilities.ApiUserToApiUserModel(apiUser);

            return apiUserModel;
        }

        #endregion

        #region [UTILITY METHODS]

        //Source: http://madskristensen.net/post/Generate-unique-strings-and-numbers-in-C.aspx
        //Author: Mads Kristensen
        //Date: Nov. 30, 2011
        public string GenerateApiKey()
        {
            long i = 1;
            byte[] guid = Guid.NewGuid().ToByteArray();

            foreach (byte b in guid)
            {
                i *= ((int)b + 1);
            }

            string apiKey = string.Format("{0:x}", i - DateTime.Now.Ticks);
            return apiKey;
        }

        public bool IsValidKey(string key)
        {
            ApiUser apiUser = db.ApiUsers.Where(u => u.ApiKey == key).FirstOrDefault();

            if (apiUser != null && apiUser.ApiCallCount <= apiUser.ApiCallLimit)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public void IncrementKeyUsage(string key)
        {
            ApiUser apiUser = db.ApiUsers.Where(u => u.ApiKey == key).FirstOrDefault();
            apiUser.ApiCallCount++;
            db.SaveChanges();
        }

        #endregion

        public void Dispose()
        {
            db.Connection.Close();
        }
    }
}

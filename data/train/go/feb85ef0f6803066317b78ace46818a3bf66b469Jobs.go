package main


type JobConfig struct {
        Id        string `json:"id" binding:"required"`
        Data string `json:"data" binding:"required"`
        Time string `json:"time" binding:"required"`
        Email     string `json:"email"`
}

// Define the Demo Jobs
func PreprocessingJob(payLoad PayLoad ) (error, PayLoad) {
        // TODO: add custom code
        return nil, nil
}

func HeavyComputationJob(payLoad PayLoad ) (error, PayLoad) {
        // TODO: add custom code
        return nil, nil
}

func CleanUpWorkspaceJob(payLoad PayLoad ) (error, PayLoad) {
        // TODO: add custom code
        return nil, nil
}

func UpdateDatabaseJobStatus(payLoad PayLoad ) (error, PayLoad) {
        // TODO: add custom code
        return nil, nil
}

func S3UploadJob(payLoad PayLoad) (error, PayLoad) {
        if urlString, err := UploadToS3(payLoad.Id, payLoad.Data); err != nil {
                return err, payLoad
        } else {
                payLoad.RemoteUrl = *urlString
        }
        return nil, payLoad
}


//Email, URL
func SendEmailJob(payLoad PayLoad) (error, PayLoad) {
        if err := SendSuccessEmail(payLoad.Email, payLoad.Id); err != nil {
                return err, payLoad
        }
        return nil, payLoad
}
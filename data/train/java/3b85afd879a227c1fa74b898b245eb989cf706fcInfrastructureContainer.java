package com.bitmechanic.jocko;

/**
 * Created by James Cooper <james@bitmechanic.com>
 * Date: Feb 6, 2010
 */
public class InfrastructureContainer implements Infrastructure {
    
    private PersistenceService persistenceService;
    private BlobService blobService;
    private MailService mailService;
    private QueueService queueService;
    private CacheService cacheService;
    private AsyncService asyncService;
    private ImageService imageService;
    private BillingService billingService;
    private LockService lockService;

    public BillingService getBillingService() {
        return billingService;
    }

    public void setBillingService(BillingService billingService) {
        this.billingService = billingService;
    }

    public AsyncService getAsyncService() {
        return asyncService;
    }

    public void setAsyncService(AsyncService asyncService) {
        this.asyncService = asyncService;
    }

    public BlobService getBlobService() {
        return blobService;
    }

    public void setBlobService(BlobService blobService) {
        this.blobService = blobService;
    }

    public CacheService getCacheService() {
        return cacheService;
    }

    public void setCacheService(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    public MailService getMailService() {
        return mailService;
    }

    public void setMailService(MailService mailService) {
        this.mailService = mailService;
    }

    public PersistenceService getPersistenceService() {
        return persistenceService;
    }

    public void setPersistenceService(PersistenceService persistenceService) {
        persistenceService.setInfrastructure(this);
        this.persistenceService = persistenceService;
    }

    public QueueService getQueueService() {
        return queueService;
    }

    public void setQueueService(QueueService queueService) {
        this.queueService = queueService;
    }

    public ImageService getImageService() {
        return imageService;
    }

    public void setImageService(ImageService imageService) {
        this.imageService = imageService;
    }

    public LockService getLockService() {
        return lockService;
    }

    public void setLockService(LockService lockService) {
        this.lockService = lockService;
    }
}

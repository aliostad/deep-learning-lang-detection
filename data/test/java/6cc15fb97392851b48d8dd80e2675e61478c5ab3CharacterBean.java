package cn.yixblog.dao.beans;

/**
 * Created with IntelliJ IDEA.
 * User: yxdave
 * Date: 13-5-24
 * Time: 下午6:46
 */
public class CharacterBean implements DatabaseEntity {
    private int id;
    private String name;
    private boolean systemConfig = false;
    private boolean userManage = false;
    private boolean adminManage = false;
    private boolean articleManage = false;
    private boolean commentManage = false;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isSystemConfig() {
        return systemConfig;
    }

    public void setSystemConfig(boolean systemConfig) {
        this.systemConfig = systemConfig;
    }

    public boolean isUserManage() {
        return userManage;
    }

    public void setUserManage(boolean userManage) {
        this.userManage = userManage;
    }

    public boolean isAdminManage() {
        return adminManage;
    }

    public void setAdminManage(boolean adminManage) {
        this.adminManage = adminManage;
    }

    public boolean isArticleManage() {
        return articleManage;
    }

    public void setArticleManage(boolean articleManage) {
        this.articleManage = articleManage;
    }

    public boolean isCommentManage() {
        return commentManage;
    }

    public void setCommentManage(boolean commentManage) {
        this.commentManage = commentManage;
    }
}

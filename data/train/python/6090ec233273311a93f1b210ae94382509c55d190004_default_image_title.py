# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations

IMAGE_TITLES = {"Azure 云服务高级功能":"Azure-Cloud Services-Advanced-Features",
                "Azure媒体服务动态打包介绍":"Media Services-Dynamically-Package",
                "Azure移动服务的数据管理":"Azure-Mobile Services-Data Management",
                "Azure管理存储文件及管理工具":"Manage-Storage File-And-Management Tools",
                "Azure网站的扩展功能":"Azure-Websites-Extended-Features",
                "Azure虚拟机高级使用技巧":"Azure-VM-Advanced-Usage",
                "Azure虚拟网络介绍":"Networking-introduction",
                "Azure高级存储简介":"Azure-Advanced-Storage-Introduction",
                "HDInsight（云上Hadoop）介绍":"HDInsight Introduction",
                "SQL数据库迁移到云端":"Migrate-SQL-To-Azure",
                "SQL数据库防火墙规则介绍":"SQL-Firewall-Rule-Introduction",
                "使用Azure移动服务开发多个平台应用":"Use-Azure-Mobile Services-To-Develop-Multi-Apps",
                "使用PowerShelll管理Traffic Manager":"Use-PowerShell-To-Manage-Traffic Manager",
                "使用Visual Studio部署应用程序到Azure云服务":"Use-Visual Studio-To-Deploy-Application-To-Cloud Services",
                "在Azure门户中创建和删除虚拟机":"Create-Delete-VM-In-Portal",
                "在Azure门户中管理Active Directory":"Manage-Active Directory-In-Portal",
                "在Azure门户中管理CDN":"Manage-CDN-In-Portal",
                "在Azure门户中管理HDInsight（云上的Hadoop）":"Manage-HDInsight-In-Portal",
                "在Azure门户中管理Service Bus":"Manage-Service Bus-In-Portal",
                "在Azure门户中管理SQL数据库":"Manage-SQL-In-Portal",
                "在Azure门户中管理Traffic Manager":"Manage-Traffic Manager-In-Portal",
                "在Azure门户中管理备份服务":"Manage-Backup Services-In-Portal",
                "在Azure门户中管理媒体服务":"Manage-Media Services-In-Portal",
                "在Azure门户中管理存储":"Mange-Storage-In-Portal",
                "在Azure门户中管理移动服务":"Manage-Mobile Services-In-Portal",
                "在Azure门户中管理网站":"Manage-Websites-In-Portal",
                "在Azure门户中管理虚拟机网络":"Manage-Networking-In-Portal",
                "在Azure门户中管理计划程序":"Manage-Scheduler-In-Portal",
                "在Azure门户中管理通知中心":"Manage-Notification hus-In-Portal",
                "在应用中使用Service Bus":"Use-Service-Bus-In-Application",
                "管理与使用Azure虚拟机":"Manage-Use-VM",
                "管理和使用通知中心功能":"Manage-And-Use-Notification hubs",
                "部署Azure网站":"Deploy-Azure-Sites",
                "Azure网站的Webjob功能":"Websites-Webjob-functionality"}

def addDataToVideo(apps, schema_editor):
    Video_link = apps.get_model("mooncakeTestEnvironment", "Video_link")
    videos = Video_link.objects.all()
    for video in videos:
        video.image_title = IMAGE_TITLES[video.title]
        video.save()


class Migration(migrations.Migration):

    dependencies = [
        ('mooncakeTestEnvironment', '0003_video_link_image_title'),
    ]

    operations = [
        migrations.RunPython(addDataToVideo),
    ]


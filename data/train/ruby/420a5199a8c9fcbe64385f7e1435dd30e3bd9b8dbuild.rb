
# 安装 maven uaa repository的cache库，以加快安装和运行
build :maven_uaa_repository do
  MAVEN_UAA_REPOSITORY_CACHE_NAME = "maven_uaa_repository_0.2"
  MAVEN_UAA_REPOSITORY_CACHE_URL = "http://file.ebcloud.com/maven/#{MAVEN_UAA_REPOSITORY_CACHE_NAME}.tar.gz"

  # 下载maven的repository库并解压到$HOME/.m2
  run "curl #{MAVEN_UAA_REPOSITORY_CACHE_URL} -s -o #{MAVEN_UAA_REPOSITORY_CACHE_NAME}.tar.gz"
  run "tar zxvf #{MAVEN_UAA_REPOSITORY_CACHE_NAME}.tar.gz"
  run "mv .m2 #{MAVEN_UAA_REPOSITORY_CACHE_NAME}"

  move_to_target MAVEN_UAA_REPOSITORY_CACHE_NAME
end
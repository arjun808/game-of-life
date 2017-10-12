pkg_name=gameoflife
pkg_origin=arjun808
pkg_version="7.0"
#pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_source="https://github.com/arjun808/game-of-life"
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
# pkg_shasum="TODO"
 pkg_deps=(core/jdk8 core/tomcat8)
 pkg_build_deps=(core/git core/maven)
#pkg_exports=([port]=listening_port)
pkg_exports=(
  [port]=http.port
)
pkg_expose=(port)
# pkg_include_dirs=(include)
# pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
# pkg_svc_run="bin/haproxy -f $pkg_svc_config_path/haproxy.conf"
# pkg_exports=
# pkg_exposes=(port)
# pkg_binds=(
#   [database]="port host"
# )
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
pkg_svc_user="root"
# pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
#pkg_upstream_url="http://localhost:8080/game-of-life"

do_download()
    {
        build_line "do_download() =================================================="
        cd ${HAB_CACHE_SRC_PATH}

        build_line "\$pkg_dirname=${pkg_dirname}"
        build_line "\$pkg_filename=${pkg_filename}"

        if [ -d "${pkg_dirname}" ];
        then
            rm -rf ${pkg_dirname}
        fi

        mkdir ${pkg_dirname}
        cd ${pkg_dirname}
        GIT_SSL_NO_VERIFY=true git clone https://github.com/arjun808/game-of-life.git
        return 0
    }

do_clean()
    {
        build_line "do_clean() ===================================================="
        return 0
    }

    do_unpack()
    {
        # Nothing to unpack as we are pulling our code straight from github
        return 0
    }


do_build()
{
    build_line "do_build() ===================================================="

    # Maven requires JAVA_HOME to be set, and can be set via:
    export JAVA_HOME=$(hab pkg path core/jdk8)

    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}
    mvn package
}


do_install()
    {
        build_line "do_install() =================================================="

        # Our source files were copied over to the HAB_CACHE_SRC_PATH in do_build(),
        # so now they need to be copied into the root directory of our package through
        # the pkg_prefix variable. This is so that we have the source files available
        # in the package.

        local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}"
                mkdir "$HAB_PKG_PATH/$pkg_origin/$pkg_name/$pkg_version/$pkg_release/jar"
        local final_dir="$HAB_PKG_PATH/$pkg_origin/$pkg_name/$pkg_version/$pkg_release/jar"
        mv ${source_dir}/gameoflife-web/target/gameoflife.war ${final_dir}
 #/hab/cache/src/game-of-life-0.1.37/game-of-life/gameoflife-web/target/gameoflife.war
        # Copy our seed data so that it can be loaded into Mongo using our init hook
       # cp ${source_dir}/national-parks.json $(hab pkg path ${pkg_origin}/national-parks)/
    }

do_verify()
    {
        build_line "do_verify() ==================================================="
        return 0
    }


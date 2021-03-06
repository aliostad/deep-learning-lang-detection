#!/usr/bin/env bats

load helpers

function teardown(){
	swarm_manage_cleanup
    stop_docker
}

@test "docker save image" {
    start_docker 1
    swarm_manage
    
    run docker_swarm pull busybox
    [ "$status" -eq 0 ]
    
    #make sure exist busybox image
    run docker_swarm images
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" == *"busybox"* ]]
    
    #save -o
    run docker_swarm save -o save_busybox_image_oupt.tar busybox 
    [ "$status" -eq 0 ]
    
    #saved image file exists
    [ -f save_busybox_image_oupt.tar ]
    
    #ater ok, delete tar file
    rm -f save_busybox_image_oupt.tar
}

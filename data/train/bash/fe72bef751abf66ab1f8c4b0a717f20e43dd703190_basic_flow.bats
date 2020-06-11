load "fixtures/basics"
load "fixtures/node"
load "fixtures/ca"
load "fixtures/cert"
load "fixtures/org"
load "fixtures/pairing_key"

@test "basic flow" {
  init_init
  init
  pairing_key_new
  ca_new
  node_new
  org_run
  run node_run
  [ "$status" -eq 0 ]
  cleanup
}

@test "standalone cert" {
  init_init
  init
  ca_new
  run cert_new_ca_standalone
  [ "$status" -eq 0 ]
  cleanup
}

@test "standalone cert imported ca" {
  init_init
  init
  create_external_ca
  ca_import_private
  run cert_new_ca_standalone
  [ "$status" -eq 0 ]
  cleanup
}

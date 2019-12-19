kind            = "service-resolver"
name            = "counting"
connect_timeout = "3s"
failover = {
  "*" = {
    service    = "counting"
    datacenters = ["${facilitya}","${facilityb}"]
  }
}

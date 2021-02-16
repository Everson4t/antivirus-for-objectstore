resource "oci_objectstorage_bucket" "checkinobj" {
    #Required
    compartment_id = oci_identity_compartment.ScanCompart.id
    name           = "checkinobj"
    namespace      = data.oci_objectstorage_namespace.ns.namespace

    #Optional
    object_events_enabled = true
}

resource "oci_objectstorage_bucket" "quarantine" {
    #Required
    compartment_id = oci_identity_compartment.ScanCompart.id
    name           = "quarantine"
    namespace      = data.oci_objectstorage_namespace.ns.namespace
}

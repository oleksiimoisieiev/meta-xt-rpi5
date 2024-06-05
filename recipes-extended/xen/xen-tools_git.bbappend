# Avoid redundant runtime dependency on python3-core
RDEPENDS:${PN}:remove:class-target = " ${PYTHON_PN}-core" 

require xen.inc
require xen-source.inc

PACKAGECONFIG:append = " xsm"

FILES:${PN}-flask = " /boot/xenpolicy-${XEN_REL}*"
FILES:${PN}-vchan:append = "\
    ${bindir}/vchan-node1 \
    ${bindir}/vchan-node2 \
"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/tools/vchan/vchan-node1 ${D}${bindir} 
    install -m 0755 ${S}/tools/vchan/vchan-node2 ${D}${bindir} 
}

# Remove the recommendation for Qemu for non-hvm x86 added in meta-virtualization layer
RRECOMMENDS:${PN}:remove = " qemu"

SYSTEMD_SERVICE:${PN}-xencommons:remove = " proc-xen.mount"
FILES:${PN}-xencommons:remove = " ${systemd_unitdir}/system/proc-xen.mount"

SYSTEMD_SERVICE:${PN}-proc-xen = "proc-xen.mount"
FILES:${PN}-proc-xen = "${systemd_unitdir}/system/proc-xen.mount"

SYSTEMD_PACKAGES += "\
    ${PN}-proc-xen \
    "

RDEPENDS:${PN}-devd += " \
    ${PN}-proc-xen \
    "

RDEPENDS:${PN}-xencommons += " \
    ${PN}-proc-xen \
    "

PACKAGES += "\
    ${PN}-proc-xen \
    "

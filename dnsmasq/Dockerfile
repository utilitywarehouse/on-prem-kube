FROM alpine:3.5

ENV SYSLINUX_VERSION="6.03"

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY pxelinux.cfg /var/lib/tftpboot/pxelinux.cfg

RUN apk --no-cache add dnsmasq curl tar gpgme \
 # Get syslinux files
 && curl -s -O https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz \
 && tar xzf syslinux-${SYSLINUX_VERSION}.tar.gz \
 && cp syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 /var/lib/tftpboot/ldlinux.c32 \
 && cp syslinux-${SYSLINUX_VERSION}/bios/core/pxelinux.0 /var/lib/tftpboot/pxelinux.0 \
 # Get CoreOS signing key
 && curl -s -O https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.asc \
 && gpg --trust-model always --import CoreOS_Image_Signing_Key.asc \
 # Get images
 && curl -s -O https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz \
 && curl -s -O https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig \
 && curl -s -O https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz \
 && curl -s -O https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig \
 && gpg --verify coreos_production_pxe.vmlinuz.sig \
 && gpg --verify coreos_production_pxe_image.cpio.gz.sig \
 && mv coreos_production_pxe.vmlinuz /var/lib/tftpboot/coreos_production_pxe.vmlinuz \
 && mv coreos_production_pxe_image.cpio.gz /var/lib/tftpboot/coreos_production_pxe_image.cpio.gz \
 # Set permissions for dnsmasq
 && chown -R dnsmasq:dnsmasq /var/lib/tftpboot/ \
 && chmod -R a+r /var/lib/tftpboot/

ENTRYPOINT ["/usr/sbin/dnsmasq"]

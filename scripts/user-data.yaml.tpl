#cloud-config
apt:
  sources:
    cyclecloud:
      source: "deb [signed-by=$KEY_FILE] https://packages.microsoft.com/repos/cyclecloud stable main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v1.4.7 (GNU/Linux)

        mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
        LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
        7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
        OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
        H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
        M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
        ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
        AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
        /32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
        MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
        7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
        KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
        XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
        NdCFTW7wY0Fb1fWJ+/KTsC4=
        =J6gs
        -----END PGP PUBLIC KEY BLOCK-----

package_update: true
packages:
  - python3.8-venv
  - unzip

runcmd:
  # Install CycleCloud
  - apt-get install -yq openjdk-8-jdk
  - update-java-alternatives -s java-1.8.0-openjdk-amd64
  - apt-get install -yq cyclecloud8
  - bash `find /opt/cycle_server/.installer -maxdepth 1 -type d | grep '/opt/cycle_server/.installer'` /install.sh --force
  - /opt/cycle_server/cycle_server await_startup
  - unzip /opt/cycle_server/tools/cyclecloud-cli.zip -d /tmp
  - python3 /tmp/cyclecloud
# Notes

    tctl users add joe joe,root

    /usr/local/bin/teleport start --roles=auth,proxy

    ./tctl auth export --type=user > ~/teleport-ca.pub

    tsh --user=james ssh root@10.0.0.174

## SSO

[SSO URL](https://accounts.google.com/o/saml2/idp?idpid=C02dhxgzt)

[Entity ID](https://accounts.google.com/o/saml2?idpid=C02dhxgzt)

**You'll need to upload Google IDP data on Tidal Teleport Demo administration panel to complete SAML configuration process**.

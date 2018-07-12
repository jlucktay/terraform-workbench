# Teleport notes for PX1021

## Enquiries from 2018-07-05 walkthrough

### How nodes are classified

Labels, which are either static or dynamic: [further reading](https://gravitational.com/teleport/docs/admin-guide/#labeling-nodes).

### Playback files

- Storage?

- File format?

- Portability?

### Entry points

- Auth
  - ELB (port 3025)
  - Auth, 2x EC2s

- Monitor
  - ELB (port 8086)
  - Grafana monitor, 1x EC2

- Proxy
  - Route 53
  - ELB
    - Port 443
      - ...
    - Port 3023
      - ...
    - Port 8443
      - Grafana monitor, 1x EC2

## Followups from Gravitational

### Pricing models

- Per seat
- Elastic node count
- Cloud marketplace (special AMIs with $/hour)

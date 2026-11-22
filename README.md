# Zero Trust Network Lab: Micro-Segmentation with Cilium + Hubble

A hands-on Zero Trust lab mapped to the **Networks pillar of the CISA Zero Trust Maturity Model v2.0**. A flat Kubernetes network hosting a three-tier HR Portal is replaced with identity-based, application-aware micro-perimeters.

> Built during the graduate course CYBR 620 at UMBC. The environment comes from a course starter kit. The network policies I write and the lab configuration are my own work.

## Planned scope

- Flat-network baseline and reachability matrix
- Default deny for the `hr` segment
- Identity-based (label) micro-segmentation
- Layer 7 (HTTP method and path) rules
- DNS-name-based egress control
- Attack simulation with Hubble flow telemetry
- WireGuard node-to-node encryption

## Tech stack

kind · Kubernetes · Cilium (eBPF) · Hubble · kubectl · nmap · curl · Docker

_Status: in progress._

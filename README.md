# How To

```shell
git clone https://github.com/msekletar/systemd-pr9982-integration-test.git
cd systemd-pr9982-integration-test
vagrant up # Wait a bit for provisioning to finish
vagrant ssh -c 'sudo reboot'
vagrant ssh # Verify that luks device was unlocked and attached automatically
```

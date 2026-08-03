---
name: docker-teardown
description: Stop and remove the addressbook Docker container and delete the addressbook Docker image. Use when the user asks to tear down, clean up, stop, remove, or delete the addressbook Docker container/image.
---

Counterpart to `docker-build-run`. Tears down what that skill creates: a container named
`addressbook` and an image tagged `addressbook:latest` (or whatever name/tag the user specified when
building).

## Steps

1. Check what's actually there before removing anything:
   ```
   docker ps -a --filter name=addressbook
   docker images addressbook
   ```
   If nothing matches, say so and stop — don't run removal commands against nothing.
2. Stop and remove the container (combine into one step if it's running):
   ```
   docker rm -f addressbook
   ```
   If the container name/state doesn't match what's expected (e.g. multiple containers from the
   image, or a container with a different name using the image), list them and ask which to remove
   rather than guessing.
3. Remove the image:
   ```
   docker rmi addressbook:latest
   ```
   If this fails because another container (not just `addressbook`) still references the image, list
   the dependent containers and ask before force-removing (`docker rmi -f`).
4. Confirm cleanup: re-run `docker ps -a --filter name=addressbook` and `docker images addressbook`
   and show the user both are now empty.
5. Do **not** run broader cleanup (`docker system prune`, removing unrelated images/containers,
   clearing build cache) unless the user explicitly asks — this skill only touches the addressbook
   container and image.

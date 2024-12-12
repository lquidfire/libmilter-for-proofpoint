## Patches for Proofpoint to patch `sendmail` so that `libmilter` can be built as a dynamic shared object (`libmilter.so`).

_Update: This was sent to Proofpoint on 8 December 2024_

Many downstream users (Linux distributions, as well as FreeBSD and others) patch `sendmail` (or `libmilter`, if they package this separately) to build a shared object of `libmilter`.

This is an attempt to create a patch to send to upstream (Proofpoint) in the hope that they will implement this feature upstream.

The steps taken in this project to create a shared object are:

1. Copy the directory `${SRC}/libmilter` to `${SRC}/libsharedmilter`
2. Create `${SRC}/devtools/M4/UNIX/sharedlibrary.m4`
3. Adapt `${SRC}/libsharedmilter/Makefile.m4` to build a shared object
4. Update various README files

The reason for building a shared object in a new directory, rather than the build process to the current `libmilter` feature, is that not al OS's that support `sendmail` use shared objects (e.g. AIX). Hence, we leave it to the builder of `sendmail` / `libmilter` to decide which version needs to be built.

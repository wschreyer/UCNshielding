#!/bin/sh

$FLUPRO/flutil/fff usimbs.f
$FLUPRO/flutil/lfluka -o myfluka -m fluka usimbs.o

#!/bin/bash
echo scratch.rs | entr -r sh -c 'clear && rustc scratch.rs && ./scratch'

#!/bin/bash 
echo $1
case $1 in
     serve) 
          jekyll server
          ;;
     build)      
          jekyll build
          echo "Page builded"
          ;;
     *)
          echo "No arguments"
          exit
          ;;
esac
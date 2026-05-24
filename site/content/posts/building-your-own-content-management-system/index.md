---
title: Building Content Management Sensibly
date: '2026-05-23'
draft: false
featured: false
excerpt: Basalt - a custom content management system
---










## Static Websites and Managing Content
![024](/assets/instagram/024/600.jpg)

A dream photo website has always been something which is incredibly fast, visually simple and easy to see the artwork, and manageable everywhere in a flash. 

I built my own system for just that, which I call *Basalt*. 

*Basalt* is a small engine which manages a static website via a small administrative panel, managing edits, uploads, builds as all in one. 

The architecture uses Hugo as a foundation for the static site and GitHub and Cloudflare for the code base, build, and hosting. 

Hugo is great because it is well developed and provides a robust architecture for static website presentation and structure. But the issue has always been the handoff between editing and compiling. There are a few options out there for content management systems for Hugo, but theyâre sticky and on some cost ladder. *Basalt* is the answer tailored to my specific needs. Built with a pipeline for bulk uploads and a sensible admin panel for uploads and management everywhere, this system uses some of the cheap and easy to use features from Cloudflare in concert with our Hugo frontend. And a key feature is the codebase is managed with GitHub, but the heavy pictures are excluded from GitHub. We rely on the seamless help of workers from Cloudflare to resize and serve our images after theyâre uploaded.  

So in the end, we have a compiled static site on the front for snappy viewing experience paired with a simple backend to edit, trigger builds, and manage content on the back. Designed for on the go and microscopic overhead. 

https://github.com/adobebulk/basalt

![002](/assets/draft-stock/002/600.jpg)
![004](/assets/draft-stock/004/600.jpg)
![003](/assets/draft-stock/003/600.jpg)
![001](/assets/draft-stock/001/600.jpg)


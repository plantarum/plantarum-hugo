publish: build
	rsync -vr --exclude '/tutorials/data' public/ tws@cabbagetown:/var/www/html/

build:
	./BuildBlog.r

rebuild:
	./RebuildBlog.r

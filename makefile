publish: build
	rsync -vr public/ tws@cabbagetown:/var/www/html/

build:
	./BuildBlog.r


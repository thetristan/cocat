all :
	node_modules/.bin/coffee --compile --output lib/ src/

test : all
	node_modules/.bin/mocha --recursive --compilers coffee:coffee-script test/

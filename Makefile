all: handlebars coffee

coffee:
	coffee -m -w -c ratigon.coffee main.coffee

handlebars:
	handlebars review.handlebars -f review.handlebars.js -k each -k if

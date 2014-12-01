all: less handlebars coffee

coffee:
	coffee -m -w -c ratigon.coffee main.coffee

less:
	lessc style.less style.css

handlebars:
	handlebars review.handlebars -f review.handlebars.js -k each -k if

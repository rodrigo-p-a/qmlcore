/**
 * @constructor
 */

exports.Element = function(dom) {
	_globals.core.EventEmitter.apply(this)
	this.dom = dom
	this._styles = {}
}

exports.Element.prototype = Object.create(_globals.core.EventEmitter.prototype)
exports.Element.prototype.constructor = exports.Element

exports.Element.prototype.addClass = function(cls) {
	this.dom.classList.add(cls)
}

exports.Element.prototype.setHtml = function(html) {
	var dom = this.dom
	this._fragment.forEach(function(node) { dom.removeChild(node) })
	this._fragment = []

	if (html === '')
		return

	var fragment = document.createDocumentFragment()
	var temp = document.createElement('div')

	temp.innerHTML = html
	while (temp.firstChild) {
		this._fragment.push(temp.firstChild)
		fragment.appendChild(temp.firstChild)
	}
	dom.appendChild(fragment)
}

exports.Element.prototype.width = function() {
	return this.dom.offsetWidth
}

exports.Element.prototype.height = function() {
	return this.dom.offsetHeight
}

exports.Element.prototype.style = function(name, style) {
	if (style !== undefined) {
		if (style !== '') //fixme: replace it with explicit 'undefined' syntax
			this._styles[name] = style
		else
			delete this._styles[name]
		this.updateStyle()
	} else if (name instanceof Object) { //style({ }) assignment
		for(var k in name) {
			var value = name[k]
			if (value !== '') //fixme: replace it with explicit 'undefined' syntax
				this._styles[k] = value
			else
				delete this._styles[k]
		}
		this.updateStyle()
	}
	else
		return this._styles[name]
}


exports.Element.prototype.updateStyle = function() {
	var element = this.element
	if (!element)
		return

	/** @const */
	var cssUnits = {
		'left': 'px',
		'top': 'px',
		'width': 'px',
		'height': 'px',

		'border-radius': 'px',
		'border-width': 'px',

		'margin-left': 'px',
		'margin-top': 'px',
		'margin-right': 'px',
		'margin-bottom': 'px'
	}

	var rules = []
	for(var name in this._styles) {
		var value = this._styles[name]
		var rule = []

		var prefixedName = this.getContext().getPrefixedName(name)
		rule.push(prefixedName !== false? prefixedName: name)
		if (Array.isArray(value))
			value = value.join(',')

		var unit = (typeof value === 'number')? cssUnits[name] || '': ''
		value += unit

		var prefixedValue = window.Modernizr.prefixedCSSValue(name, value)
		rule.push(prefixedValue !== false? prefixedValue: value)

		rules.push(rule.join(':'))
	}

	var dom = element[0]
	dom.setAttribute('style', rules.join(';'))
}

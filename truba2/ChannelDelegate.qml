Rectangle {
	id: channelDelegateProto;
	property bool toggled: false;
	width: parent.width;
	height: channelLabelText.paintedHeight * 3.5;
	color: colorTheme.focusablePanelColor;
	clip: true;

	Rectangle {
		anchors.fill: parent;
		color: channelDelegateProto.toggled ? colorTheme.accentColor : colorTheme.activeFocusColor;
		visible: parent.activeFocus;

		Behavior on color { ColorAnimation { duration: 300; } }
	}

	Rectangle {
		id: logoBg;
		width: height;
		color: model.color;
		anchors.top: parent.top;
		anchors.left: parent.left;
		anchors.bottom: parent.bottom;

		Rectangle {
			color: "#0000";
			anchors.fill: parent;
			anchors.topMargin: 4;
			anchors.leftMargin: 4;
			anchors.bottomMargin: 4;
			border.width: 4;
			border.color: colorTheme.activeFocusColor;
			visible: channelDelegateProto.activeFocus;
		}

		Image {
			anchors.fill: parent;
			anchors.margins: 10;
			fillMode: Image.PreserveAspectFit;
			source: model.source;
		}
	}

	MainText {
		id: channelLabelText;
		anchors.top: parent.top;
		anchors.left: logoBg.right;
		anchors.right: parent.right;
		anchors.margins: 10;
		text: model.text;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.accentTextColor;
		font.bold: true;
	}

	MainText {
		anchors.left: logoBg.right;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		anchors.leftMargin: 10;
		anchors.rightMargin: 10;
		anchors.bottomMargin: 20;
		text: model.program.start + (model.program.start ? "-" : "") + model.program.stop + " " + model.program.title;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.textColor;
	}

	Item {
		height: 3;
		anchors.left: logoBg.right;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		anchors.leftMargin: 10;
		anchors.rightMargin: 10;
		anchors.bottomMargin: 10;

		Rectangle {
			id: programProgress;
			width: model.program.progress * parent.width;
			anchors.top: parent.top;
			anchors.left: parent.left;
			anchors.bottom: parent.bottom;
			color: colorTheme.accentColor;
		}
	}

	Timer {
		id: toggleTimer;
		interval: 300;
		repeat: false;

		onTriggered: { channelDelegateProto.toggled = false }
	}

	onSelectPressed: {
		this.toggled = true
		toggleTimer.restart()
		event.accepted = false
	}
}

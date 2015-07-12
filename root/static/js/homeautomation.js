var HomeAutomation = {};

HomeAutomation.Scene = (function ($) {
    'use strict';

    var draggedItem;

    function buildDropItem (index, appliance) {
        appliance.state = appliance.state || appliance.on;
        return $('<div>', {
                id: 'item-'+index,
                'class': 'dragItem',
            })
            .text(appliance.room + ': ' + appliance.device)
            .append(
                $('<button>', {'class':"btn-xs btn-default"})
                    .text(appliance.state)
                    .click(function () {
                        if ($(this).text() == appliance.on) {
                            appliance.state = appliance.off;
                        } else {
                            appliance.state = appliance.on;
                        }
                        $(this).text(appliance.state);
                    })
            );

    }

    function Interface (args) {
        this.input = args.input;
        this.display = args.display;
        this.appliances = args.appliances;
        this.config = [];
    }

    Interface.prototype.setConfigFromInput = function () {
        // if we already have some input, turn the JSON into our array
        if (this.input.val()) {
            var self = this;
            this.config = JSON.parse(this.input.val());
            $.each(this.config, function (index, appliance) {
                var element = buildDropItem(index, appliance);
                self.dropZone.append(element);
            });
        }
    };

    Interface.prototype.getConfiguration = function () {
        // stringify the config
        var config = JSON.stringify(this.config);
        // store it in the input field
        this.input.val(config);
    };

    // drop down element that lets you select appliances to drag
    Interface.prototype.applianceMenu = function () {
        var self = this,
            container = $('<div>', { 'class': "dropdown" }),
            button = $('<button>', {
                id:   "dLabel",
                type: "button",
                'data-toggle': "dropdown",
                'aria-haspopup': "true",
                'aria-expanded': "false",
                'class': "btn btn-default"
            }).text('Appliances').append($('<span>', { 'class': "caret" })),
            list = $('<ul>', {
                'class': "dropdown-menu",
                'aria-labelledby': "dLabel"
            });
        $.each(this.appliances, function (index, appliance) {
            var listItem = $('<li>'),
                applianceSpan = $('<span>', {
                    id: appliance.address,
                    'class': 'dragItem'
                });

            applianceSpan.text(appliance.room + ': ' + appliance.device);
            applianceSpan.draggable({
                    containment: 'document',
                    cursor:      'move',
                    revert:      true,
                    start:       function (event, ui) {
                        // on start store the appliance information
                        draggedItem = appliance;
                    }
                }).appendTo(listItem);
            listItem.appendTo(list);
        });
        container.append(button);
        container.append(list);

        return container;
    };

    // returns a jQuery element for the draggable menu
    Interface.prototype.menu = function () {
        var menu = $('<span>', { 'class': "menu" });

        this.applianceMenu().appendTo(menu);
        // TODO: implement delays
        //this.delay().appendTo(menu);

        return menu
    };

    // returns a dropable div
    Interface.prototype.dropZone = function () {
        var self = this;
        this.dropZone = $('<span>', { 'class': 'dropzone' });
        this.dropZone.droppable( {
            drop: function (event, ui) {
                
                // build up an element added to the dropZone
                var element = buildDropItem(self.config.length, draggedItem);

                // add the draggedItem to the config
                self.config.push(draggedItem);

                // delete it
                draggedItem = null;


                $(this).append(element);
            }
        });
        return this.dropZone;
    };

    Interface.prototype.render = function () {
        // build a menu and dropzone
        var container = $('<div>', { class: 'scene-container' });

        this.menu().appendTo(container),
        this.dropZone().appendTo(container);

        // put it all in the display
        this.display.html(container);
    };

    function setup (inputEl, displayEl, applianceJSON) {
        var scene = new Interface({
                input: $(inputEl),
                display: $(displayEl),
                appliances: applianceJSON
            });
        scene.render();
        scene.setConfigFromInput();

        // hook into the submit so that we can set the json of the field
        $('form').submit(function (ev) {
            // populate the hidden field with our configuration
            scene.getConfiguration();
            this.submit();
        });
    }

    return {
        setup: setup
    };
})(jQuery);

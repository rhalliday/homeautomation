var HomeAutomation = {};

HomeAutomation.Scene = (function ($) {
    'use strict';

    var draggedItem,
        counter = 0;


    function Node(args) {
        this.index = args.index;
        this.appliance = args.appliance;
        this.next = args.next || null;
        this.previous = args.previous || null;
    }

    Node.prototype.add = function (index, appliance) {
        var node = new Node({ index: index, appliance: appliance, previous: this });
        this.next = node;
        return node;
    };

    Node.prototype.remove = function () {
        // we need to set the previous nodes next to this nodes next
        if (this.previous) {
            this.previous.next = this.next;
        }
        // and our next nodes previous to this nodes previous
        if (this.next) {
            this.next.previous = this.previous;
        }
        // nullify our appliance
        this.appliance = null;
    };

    // an indexed link list to store our appliance information in
    function Configuration() {
        this.config = {};
        this.firstNode = null;
        this.lastNode = null;
    }

    // creates a node and adds the index to the config
    Configuration.prototype.add = function (index, appliance) {
        var node;
        // index needs to be unique
        if (this.config[index] !== undefined) {
            throw new Error('cannot add a duplicate node');
        }

        // if this is the firstNode then we can just create a new node
        if (!this.firstNode) {
            node = new Node({ index: index, appliance: appliance });
            // set the firstNode and last node to this node
            this.firstNode = index;
            this.lastNode = index;
            this.config[index] = node;
            return;
        }

        // else we need to create a new node with previous node set to the last node
        node = this.config[this.lastNode].add(index, appliance);
        this.config[index] = node;
        this.lastNode = index;
    };

    // delete a node from the index
    Configuration.prototype.remove = function (index) {
        var node = this.config[index];
        // delete the node from our config
        delete this.config[index];

        // if this is the lastNode, set the lastNode to the previous nodes index
        if (this.lastNode === index) {
            this.lastNode = node.previous ? node.previous.index : null;
        }

        // if this is the firstNode, set the firstNode to the next nodes index
        if (this.firstNode === index) {
            this.firstNode = node.next ? node.next.index : null;
        }

        // delete the node
        node.remove();
    };

    // return a json representation of the configuration
    // whilst destroying it
    Configuration.prototype.toJSON = function () {
        var config = [],
            nextNode,
            firstNode = this.config[this.firstNode];
        if (firstNode) {
            config.push(firstNode.appliance);
            nextNode = firstNode.next;
            firstNode.remove();
            while (nextNode) {
                config.push(nextNode.appliance);
                firstNode = nextNode;
                nextNode = firstNode.next;
                firstNode.remove();
            }
        }
        this.config = null;

        return JSON.stringify(config);
    };

    function Interface(args) {
        this.input = args.input;
        this.display = args.display;
        this.appliances = args.appliances;
        this.config = new Configuration();
    }

    Interface.prototype.buildDropItem = function (index, appliance) {
        var self = this,
            switcher = $('<label>', { 'class': 'item-state' });

        appliance.state = appliance.state || 'on';

        // switcher needs a checkbox to store the state
        switcher.append($('<input>', {
                'class': "ios-switch tinyswitch green",
                'type': "checkbox"
            })
            .prop("checked", (appliance.state === 'on'))
            .click(function () {
                if ($(this).prop("checked")) {
                    appliance.state = 'on';
                } else {
                    appliance.state = 'off';
                }
            })
        );
        // the following 2 divs are for the switches
        switcher.append($('<div><div></div></div>'));

        return $('<div>', {
            id: index,
            'class': 'dragItem',
        })
            .append($('<span>', { 'class': "item-text" }).text(appliance.room + ': ' + appliance.device))
            .append(
                $('<span>', { 'class': "glyphicon glyphicon-remove-sign alert-danger item-remove"})
                    .click(function () {
                        self.config.remove(index);
                        $('#' + index).remove();
                    })
            ).append(switcher)
            .append($('<div>', { 'class': "clearfix" }));
    };

    Interface.prototype.setConfigFromInput = function () {
        // if we already have some input, turn the JSON into our array
        if (this.input.val()) {
            var self = this,
                config = JSON.parse(this.input.val());
            $.each(config, function (index, appliance) {
                counter = index;
                var id = 'item-' + counter,
                    element = self.buildDropItem(id, appliance);
                self.config.add(id, appliance);
                self.dropZone.append(element);
            });
        }
    };

    // this renders the configuration useless
    Interface.prototype.getConfiguration = function () {
        // stringify the config
        var config = this.config.toJSON();
        this.config = null;
        // store it in the input field
        this.input.val(config);
    };

    // drop down element that lets you select appliances to drag
    Interface.prototype.applianceMenu = function () {
        var container = $('<div>', { 'class': "appliance" });

        // create a div for each appliance
        $.each(this.appliances, function (index, appliance) {
                var applianceSpan = $('<div>', {
                    id: appliance.address,
                    'class': 'dragItem'
                });

            applianceSpan.append($('<span class="appliance-text">').text(appliance.room + ': ' + appliance.device));
            applianceSpan.draggable({
                containment: 'document',
                cursor:      'move',
                revert:      true,
                start:       function () {
                    // on start store the appliance information
                    draggedItem = appliance;
                    counter = counter + 1;
                }
            }).appendTo(container);
            return index;
        });

        return container;
    };

    // returns a jQuery element for the draggable menu
    Interface.prototype.menu = function () {
        var menu = $('<span>', {
            'class': "menu",
            title:   "Drag an item from here and drop it into the scene"
        });

        menu.append($('<h1>').text('Items'));
        this.applianceMenu().appendTo(menu);
        // implement delays
        //this.delay().appendTo(menu);

        return menu;
    };

    // returns a dropable div
    Interface.prototype.dropZone = function () {
        var self = this;
        this.dropZone = $('<span>', {
            'class': 'dropzone',
            title:   "Click the switches to indicate if the appliance should be turned on or off"
        });
        this.dropZone.droppable({
            drop: function () {
                // build up an element added to the dropZone
                var id = 'item-' + counter,
                    element = self.buildDropItem(id, draggedItem);

                // add the draggedItem to the config
                self.config.add(id, draggedItem);

                // delete it
                draggedItem = null;


                $(this).append(element);
            }
        });
        this.dropZone.append($('<h1>').text('Scene'));
        return this.dropZone;
    };

    Interface.prototype.render = function () {
        // build a menu and dropzone
        var container = $('<div>', { class: 'scene-container' });

        this.menu().appendTo(container);
        this.dropZone().appendTo(container);

        // put it all in the display
        this.display.html(container);
    };

    function setup(inputEl, displayEl, applianceJSON) {
        var scene = new Interface({
                input: $(inputEl),
                display: $(displayEl),
                appliances: applianceJSON
            });
        scene.render();
        scene.setConfigFromInput();

        // hook into the submit so that we can set the json of the field
        $('form').submit(function () {
            // populate the hidden field with our configuration
            scene.getConfiguration();
            this.submit();
        });
    }

    return {
        setup: setup
    };
}(jQuery));

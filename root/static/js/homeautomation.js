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
        var self = this;
        appliance.state = appliance.state || appliance.on;
        return $('<div>', {
            id: index,
            'class': 'dragItem',
        })
            .text(appliance.room + ': ' + appliance.device)
            .append(
                $('<button>', {'class': "btn-xs btn-default"})
                    .text(appliance.state)
                    .click(function () {
                        if ($(this).text() === appliance.on) {
                            appliance.state = appliance.off;
                        } else {
                            appliance.state = appliance.on;
                        }
                        $(this).text(appliance.state);
                    })
            ).append(
                $('<button>', { 'class': "btn-xs btn-danger"})
                    .text('Delete')
                    .click(function () {
                        self.config.remove(index);
                        $('#' + index).remove();
                    })
            );
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
        var container = $('<div>', { 'class': "dropdown" }),
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
                start:       function () {
                    // on start store the appliance information
                    draggedItem = appliance;
                    counter = counter + 1;
                }
            }).appendTo(listItem);
            listItem.appendTo(list);
            return index;
        });
        container.append(button);
        container.append(list);

        return container;
    };

    // returns a jQuery element for the draggable menu
    Interface.prototype.menu = function () {
        var menu = $('<span>', { 'class': "menu" });

        this.applianceMenu().appendTo(menu);
        // implement delays
        //this.delay().appendTo(menu);

        return menu;
    };

    // returns a dropable div
    Interface.prototype.dropZone = function () {
        var self = this;
        this.dropZone = $('<span>', { 'class': 'dropzone' });
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

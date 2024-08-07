# flutter_reorderableList_debug


This is an attempt to find solutions for finishing a Flutter project.


# The Problem


The program is supposed to help plan various processes, loosely grouped under the name "experiment" or, more loosely, "project" (this sample begins with a "recipe," because that is a process everyone should understand).
The first step is to make an inventory of resources (not included here, since that part works), followed by a rough description of the aims of the "experiment," after which the user makes a "to do" or "task" list.
The idea was to make it possible to reorder this list as it is built, because the user might think of tasks that need to be added and wedged in between other tasks.
So, when cooking, one might decide to "prepare ingredients" and then "bake a cake," but decide that they also need to "warm up the oven" before baking the cake...


The task list is complicated because it combines list building (ListView.builder, etc.) with a reorderable list (ReorderableListView.builder).
After a lot of trial and error, I have managed to combine these two (tasks_reorder.dart), but raised a few more problems.
Obviously I don't want to list all possible tasks in the "to do" list, only those related to a given "experiment."
So, the user moves from the "experiment design" (design_recipe.dart) page to the task list, and the "project design" name is registered in the database ("designName"), and only the tasks related to that project are displayed on the list page.
These tasks can be reordered, but... so far the items in the list are displayed according to the registry key numbers ("id"), and I have been unable to get them to display according to a more complete SQL query ("sort by newIndex WHERE designName = xxx").
Among other things, this leaves blank spaces when the "newIndex" numbers do not correspond to the registry keys.


I am working on the SQFLITE queries, but among other things, the standard "oldIndex" and "newIndex" examples used in the Reorderable list documentation only seem to update the moved item, but not the rest of the list, so some items end up having the same index number.


The next problem is exporting the ordered task list to a json format that can be deserialized using the diagram_editor (https://pub.dev/packages/diagram_editor), and then getting diagram_editor to access the resulting json files.


Any suggestions on how to solve these problems would be greatly appreciated.
 
 

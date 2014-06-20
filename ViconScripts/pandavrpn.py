
import direct.directbase.DirectStart
from pandac.PandaModules import *
from direct.task import Task
from direct.showbase import *
import random
import sys
import math

# vrpn_server -millisleep 1 -f vrpn_flock.cfg

class World(DirectObject.DirectObject):
  def __init__(self):
        # Accept the Esc key to quit the game.
    self.accept("escape", sys.exit)

    self.vrpnclient = VrpnClient ('localhost')
    self.tracker0 = TrackerNode(self.vrpnclient,"calibrationWand")
    taskMgr.add (self.update,"update")

    self.wand=loader.loadModel("zup-axis")
    self.wand.reparentTo(render)
        # this is a node in the scenegraph.  you can attach stuff to it which will be visible.
    self.myTrackedNode = render.attachNewNode('myTrackedNode')  
   
        # this is the data node that gets the tracker info
        # it is NOT in the scenegraph, but in the mysterious data graph
    base.dataRoot.node().addChild(self.tracker0)
   
   
    t2n = Transform2SG('t2n')
    self.tracker0.addChild(t2n)
   
    t2n.setNode(self.myTrackedNode.node())

        # i think this should work:
        # cube=loader.loadModel("cube")
        # cube.reparentTo(self.myTrackedNode)
   
    #base.disableMouse()
    #	camera.setPos(0,-10,0)
    camera.lookAt(0,0,0)

  def update (self,t):
    self.vrpnclient.poll()
    #camera.setPos(self.myTrackedNode.getPos())
    #camera.setHpr (self.myTrackedNode.getHpr())

    #print self.myTrackedNode.getPos()*1000, self.myTrackedNode.getHpr()
   
    p=self.myTrackedNode.getPos()
   
    #p2 = int(p.getX()*100), int (p.getY() * 100), int(p.getZ() * 100)
    print p   

    self.wand.setPos(p*10)
    #self.wand.setHpr(self.myTrackedNode.getHpr())

    #print self.wand.getPos()
    return Task.cont

 

w=World()
run()

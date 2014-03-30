
import direct.directbase.DirectStart
from pandac.PandaModules import *
from direct.task import Task
from direct.showbase import *
import random
import sys
import math
import OSC

client = OSC.OSCClient()
client.connect( ('129.161.12.174', 6666) )

# store tracked objects in a nice tidy array

class TrackedObject():
    def __init__(self, vrpnClient, vrpnName, oscClient, oscName):
        self.vrpnClient = vrpnClient
        self.oscClient = oscClient
        self.vrpnName = vrpnName
        self.oscName = oscName
        self.trackerNode = TrackerNode (self.vrpnClient,vrpnName)
        self.transform = render.attachNewNode(vrpnName)
        base.dataRoot.node().addChild(self.trackerNode)
        self.t2sg = Transform2SG(vrpnName)
        self.trackerNode.addChild(self.t2sg)
        self.t2sg.setNode(self.transform.node())
        
    def update(self):
        vp = self.transform.getPos()
        vr = self.transform.getHpr()
        msg = OSC.OSCMessage()
        msg.setAddress(self.oscName)
        msg.append("%f %f %f %f %f %f"%(vp.getX() *.9, vp.getY()*.9 , vp.getZ() *.9, vr.getX(), vr.getY(), vr.getZ())) 
        
        self.oscClient.send(msg)

class World(DirectObject.DirectObject):
    def __init__(self):
    # Accept the Esc key to quit the game.
        self.accept("escape", sys.exit)
        taskMgr.add (self.update,"update")
        self.vrpnClient = VrpnClient ('localhost')
        
        self.trackedObjects=[]
        self.trackedObjects.append (TrackedObject(self.vrpnClient,"visor", client, "/visor"))
        #self.trackedObjects.append (TrackedObject(self.vrpnClient,"wand",client,"/wand"))
        
        camera.lookAt(0,0,0)

    def update (self,t):
        self.vrpnClient.poll()
       
        for obj in self.trackedObjects:
            obj.update()

        return Task.cont

 

w=World()
run()

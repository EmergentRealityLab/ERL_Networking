
import direct.directbase.DirectStart
from pandac.PandaModules import *
from direct.task import Task
from direct.showbase import *
import random
import sys
import math
import OSC

client = OSC.OSCClient()
client.connect( ('129.161.12.207', 6666) )


class World(DirectObject.DirectObject):
    def __init__(self):
    # Accept the Esc key to quit the game.
        self.accept("escape", sys.exit)

        self.vrpnclient = VrpnClient ('localhost')
        self.tracker0 = TrackerNode(self.vrpnclient,"visor")
        self.tracker1 = TrackerNode(self.vrpnclient,"wand")
        self.tracker2 = TrackerNode(self.vrpnclient, "redhat")
        taskMgr.add (self.update,"update")

        self.trackedVisorNode = render.attachNewNode('trackedVisorNode')  
        base.dataRoot.node().addChild(self.tracker0)
        
        self.trackedWandNode = render.attachNewNode('trackedWandNode')  
        base.dataRoot.node().addChild(self.tracker1) 

        self.trackedRedHatNode = render.attachNewNode('trackedRedHatNode')  
        base.dataRoot.node().addChild(self.tracker2) 
       
        t2nVisor = Transform2SG('t2nVisor')
        self.tracker0.addChild(t2nVisor)      
        t2nVisor.setNode(self.trackedVisorNode.node())
        
        t2nWand = Transform2SG('t2nWand')
        self.tracker1.addChild(t2nWand)      
        t2nWand.setNode(self.trackedWandNode.node())
        
        t2nRedHat = Transform2SG('t2nRedHat')
        self.tracker2.addChild(t2nRedHat)      
        t2nRedHat.setNode(self.trackedRedHatNode.node())

        camera.lookAt(0,0,0)

        self.display1 = aspect2d.attachNewNode(TextNode('display1'))
        self.display1.node().setText("0 0 0")
        self.display1.setScale(0.1)
        self.display1.setPos(-1,0,0)
        
        self.display2 = aspect2d.attachNewNode(TextNode('display2'))
        self.display2.node().setText("0 0 0")
        self.display2.setScale(0.1)
        self.display2.setPos(0,0,0)
        
        #initialize kalman filters
        #pos
        self.kpx = KalmanFilter()
        self.kpy = KalmanFilter()
        self.kpz = KalmanFilter()
        #rotation
        self.krx = KalmanFilter()
        self.kry = KalmanFilter()
        self.krz = KalmanFilter()
        
        
    def update (self,t):
        self.vrpnclient.poll()
       
        vp = self.trackedVisorNode.getPos()
        vr = self.trackedVisorNode.getHpr()
        
        msg = OSC.OSCMessage()
        msg.setAddress("/visor")
        msg.append("%f %f %f %f %f %f"%(vp.getX() , vp.getY() , vp.getZ() , vr.getX(), vr.getY(), vr.getZ()))
        #print (vp.getX(), vp.getY(), vp.getZ())
        self.display1.node().setText("visor:\n%0.3f\n%0.3f\n%0.3f" % (vp.getX(), vp.getY(), vp.getZ()))
        #client.send(msg)
        
        wp = self.trackedWandNode.getPos()
        wr = self.trackedWandNode.getHpr()
        
        #msg = OSC.OSCMessage()
        #msg.setAddress("/wand")
        #msg.append("%f %f %f %f %f %f"%(wp.getX() , wp.getY(), wp.getZ(), wr.getX(), wr.getY(), wr.getZ() ))
        
        #conditionally initialize kalman filters
        #get around the fact it initializes after several updates...
        if not (wp.getX() == 0 and wp.getY() == 0 and wp.getZ() == 0 and wr.getX() == 0 and wr.getY() == 0 and wr.getZ() == 0):
            self.kpx.initialize( wp.getX() )
            self.kpy.initialize( wp.getY() )
            self.kpz.initialize( wp.getZ() )
            self.krx.initialize( wr.getX() )
            self.kry.initialize( wr.getY() )
            self.krz.initialize( wr.getZ() )
        
            msg.append("%f %f %f %f %f %f"%(self.kpx.filter( wp.getX() ), self.kpy.filter( wp.getY() ), self.kpz.filter( wp.getZ() ), self.krx.filter( wr.getX() ), self.kry.filter( wr.getY() ), self.krz.filter( wr.getZ() ) ))        
        
            self.display2.node().setText("wand:\n%0.3f\t%0.3f\n%0.3f\t%0.3f\n%0.3f\t%0.3f" % (wp.getX(), self.kpx.filter( wp.getX() ), wp.getY(), self.kpy.filter( wp.getY() ), wp.getZ(), self.kpz.filter( wp.getZ() )))
        
        #msg.setAddress("/redhat")
        rhp = self.trackedRedHatNode.getPos()
        rhr = self.trackedRedHatNode.getHpr()
        msg.append("%f %f %f %f %f %f"%(rhp.getX(), rhp.getY(), rhp.getZ(), rhr.getX(), rhr.getY(), rhr.getZ()))

        client.send(msg)
        
       # print vp, vr, wp, wr

        return Task.cont
         
class KalmanFilter(object):
    #Useage: filter(z) -> x at this timestep
    
    #-----------------------------------------------------
    #KALMAN FILTER
    #-----------------------------------------------------
    #adapated from:
    # http://bilgin.esme.org/BitsBytes/KalmanFilterforDummies.aspx
    # http://greg.czerniak.info/guides/kalman1/
    
    #for scalars, matrices are scalars
    
    #x sub(k) = A x sub(k - 1) + B u sub(k) + w sub(k - 1)
    #TRANSLATION: (current x = previous x + some control input + some noise)
    #Z sub(k) = H x sub(k) + v sub(k)
    #TRANSLATION: measured values are (signal value + measurement noise)
    
    #NOTES: Q and R need values that are reasonable
    #       this presently seems to slowly converge on the value, rather than filtering out jitters.
    #       it has the result that if you keep the wand almost stationary, this slow convergence will filter out jitters, though.
    
    #       It seems like we want to make the control vector = the change in the axis for the frame?
    
    def __init__( self ):
        #Global vars: I am a bad person ....
        #Set up values
        self.k = 0.0      #initial value. This is the iterator. ( think t in f(t) )
        self.prev_x = 0.0 #initial value
        self.x = 0.0      #state?
        self.prev_p = 1.0 #initial value
        self.p = 1.0      #error covariance?
        self.a = 1.0      #some coefficient (State transition scalar)
        self.b = 0.0      #some coefficient (Control scalar)
        self.h = 1.0      #some coefficient (Observation scalar)
        self.t = 1.0      #some power
        self.r = 0.0000001#% amount of noise, roughly? error in measurements
        self.u = 0.0      #?
        self.q = 0.0      #estimate of error in the process
        self.z = 0.0      #Z is your input. (z sub(k) = H sub(k) + v sub(k)) (measured vals are signal + noise)
        self.g = 0.0      #G is the kalman gain

    def predict( self ):
        #project the state ahead
        #analysis: predicted x = previous x
        self.x = self.a * self.prev_x + self.b * self.u #u sub(k) is 0?
        #project the error covaraince
        #analysis: predicted p = previous p + q
        #self.p = self.a * self.prev_p * math.pow(self.a, self.t) + self.q #should q here be q times some gaussian random factor?
        self.p = self.a * self.prev_p * self.a + self.q #simplify

    def correct( self ):
 
        #compute the kalman gain (g)... I use g instead of K sub (k) b/c K vs k is confusing
        #analysis: g = p / (p + r)
        #self.g = self.prev_p * math.pow(self.h, self.t) / ( (self.h * self.prev_p * math.pow(self.h, self.t)) + self.r)
        self.g = self.prev_p * self.h / ( (float(self.h) * float(self.prev_p) * float(self.h)) + self.r) #simplify
        #update the estimate via z
        #analysis: x = prev x + g * (z - prev x) OR the change.
        self.x = self.prev_x + self.g * (self.z - self.h * self.prev_x)
        #update the error covariance
        # p = p - pp / (p + r)
        self.p = (1.0 - self.g * self.h) * self.prev_p
        #print
        #print( "z = " + str(self.z) + ", p = " + str(self.p) )
        #print( "x = " + str(self.x) )

    def main( self ):
        #TODO: Get the measured value, or Z
     
        self.predict()
        self.correct()
        #update indecies
        self.k = self.k + 1
        self.prev_x = self.x
        self.prev_p = self.p
        
    def filter( self, input ):
        self.z = input
        self.main()
        return self.x
        
    def initialize( self, initial_value ):
        if self.k == 0:
            self.prev_x = initial_value
            self.x = initial_value
            #print( initial_value ) #DEBUG
        

w=World()
run()

# linear kalman filter 
# adapted from:
# http://greg.czerniak.info/guides/kalman1/

# for input values that are discrete scalars, the matrices are also simplified as scalars



class KalmanFilterLinear:
    def __init__(self,_P,Q,_R,_x=0.0,_A=1.0,_B=1.0,_H=1.0:
        self.A=_A   # state transition scalar
        self.B=_B   # Control scalar
        self.H=_H   # Observation scalar
        self.current_state_estimate = _x # initial state estimate 
        self.current_prob_estimate  = _P # initial covariance estimate
        self.Q=_Q   # Estimated error in process
        self.R=_R   # Estimated error in measurements
        
    def GetCurrentState (self):
        return self.current_state_estimate
        
    def Step(self,control_vector,measurement_vector=0):
        # prediction 
        # first, predict next value based purely on last value 
        # and predict how much noise there will be by modeling the noise in the process itself
        
        predicted_state_estimate = self.A * self.current_state_estimate + self.B * control_vector
        predicted_prob_estimate = (self.A * self.current_prob_estimate) * self.A + self.Q
        
        # observation: compare the measurement against the predicted state
        # 
        
        innovation = measurement_vector - self.H * predicted_state_estimate
        innovation_covariance = self.H * predicted_prob_estimate  * self.H + self.R
        
        # update
        
        kalman_gain = predicted_prob_estimate * numpy.transpose(self.H) * ( 1/innovation_covariance )     
        self.current_state_estimate = predicted_state_estimate + kalman_gain * innovation
        
        size=self.current_prob_estimate.shape[0]
        self.current_prob_estimate = (numpy.eye(size)-kalman_gain*self.H)*predicted_prob_estimate
        
        
        
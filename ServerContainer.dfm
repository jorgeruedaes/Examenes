object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  Height = 127
  Width = 243
  object DSServer1: TDSServer
    Left = 136
    Top = 19
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 48
    Top = 19
  end
end

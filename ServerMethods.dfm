object Metodos: TMetodos
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 188
  Width = 518
  object sqlFBConexion: TFDConnection
    LoginPrompt = False
    BeforeConnect = sqlFBConexionBeforeConnect
    Left = 16
    Top = 8
  end
  object sqlQuery: TFDQuery
    Connection = sqlFBConexion
    Left = 88
    Top = 8
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 392
    Top = 16
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 232
    Top = 64
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 232
    Top = 16
  end
end

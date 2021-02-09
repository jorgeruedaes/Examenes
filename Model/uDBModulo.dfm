object DBModulo: TDBModulo
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 153
  Width = 545
  object sqlFBConexion: TFDConnection
    LoginPrompt = False
    BeforeConnect = sqlFBConexionBeforeConnect
    Left = 16
    Top = 8
  end
  object sqlQuery: TFDQuery
    Connection = sqlFBConexion
    Left = 96
    Top = 8
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 392
    Top = 16
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 184
    Top = 8
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 280
    Top = 16
  end
end

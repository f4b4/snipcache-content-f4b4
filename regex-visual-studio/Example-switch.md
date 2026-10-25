Find:      (case PropStatus\.(\w)\w+:)\r\n.*break;

Replace:   $1 return '$2';

Vorher:

                case PropStatus.None:
                    break;
                case PropStatus.Mandatory:
                    break;
                case PropStatus.Required:
                    break;
                case PropStatus.Dependent:
                    break;
                case PropStatus.Adviced:
                    break;
                case PropStatus.Optional:
                    break;
                case PropStatus.NotUsed:
                    break;
                case PropStatus.InternesFeld:
                    break;

Nachher:
                case PropStatus.None:         return 'N';
                case PropStatus.Mandatory:    return 'M';
                case PropStatus.Required:     return 'R';
                case PropStatus.Dependent:    return 'D';
                case PropStatus.Adviced:      return 'A';
                case PropStatus.Optional:     return 'O';
                case PropStatus.NotUsed:      return 'N';
                case PropStatus.InternesFeld: return 'I';

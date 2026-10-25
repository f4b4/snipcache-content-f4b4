Input:
        public int? NameScore { get; set; }

Output:
        int? _NameScore;

		public int? NameScore
		{
			get { return _NameScore; }
			set { SetValue(() => NameScore, value ref _NameScore); }
		}


Version 1
-------------------------------

Find what:
public (\w+\??) (\w+) \{ get; set; \}

Replace with:
\1 _\2;\n\n\t\tpublic \1 \2\n\t\t{\n\t\t\tget { return _\2; }\n\t\t\tset { SetValue\(\(\) => \2, value, ref _\2\); }\n\t\t}\n

Version 2
-------------------------------

Find what:
^\s*public (\w+) (\w+) \{.*\}

Replace with:
public \1 \2\n{\nget { return _\2; }\nset { SetValue\(\(\) => \2, value, ref _\2\); }\n}\n\1 _\2;\n
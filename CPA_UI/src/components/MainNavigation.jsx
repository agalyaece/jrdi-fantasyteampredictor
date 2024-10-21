import { NavLink } from 'react-router-dom';
import { useState } from 'react';
import classes from './MainNavigation.module.css';


export default function MainNavigation() {

  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <header className={classes.header} >
      <nav>
        <div className={classes.menu} onClick={() => setMenuOpen(!menuOpen)}>
          <span></span>
          <span></span>
          <span></span>
        </div>
        <ul className={ menuOpen ? `${classes.open}` : undefined}>
          <li>
            <NavLink
              to="/fantasy"
              className={({ isActive }) =>
                isActive ? classes.active : undefined
              }
              end
            >
              Fantasy
            </NavLink>
          </li>
          <li>
            <NavLink
              to="/statistics"
              className={({ isActive }) =>
                isActive ? classes.active : undefined
              }
            >
              Statistics
            </NavLink>
          </li>
          <li>
            <NavLink
              to="/administration"
              className={({ isActive }) =>
                isActive ? classes.active : undefined
              }
            >
              Administration
            </NavLink>
          </li>
        </ul>
      </nav>
    </header>
  );
}

